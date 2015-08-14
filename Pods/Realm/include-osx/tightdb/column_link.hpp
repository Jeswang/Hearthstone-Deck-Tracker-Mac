/*************************************************************************
 *
 * TIGHTDB CONFIDENTIAL
 * __________________
 *
 *  [2011] - [2012] TightDB Inc
 *  All Rights Reserved.
 *
 * NOTICE:  All information contained herein is, and remains
 * the property of TightDB Incorporated and its suppliers,
 * if any.  The intellectual and technical concepts contained
 * herein are proprietary to TightDB Incorporated
 * and its suppliers and may be covered by U.S. and Foreign Patents,
 * patents in process, and are protected by trade secret or copyright law.
 * Dissemination of this information or reproduction of this material
 * is strictly forbidden unless prior written permission is obtained
 * from TightDB Incorporated.
 *
 **************************************************************************/
#ifndef TIGHTDB_COLUMN_LINK_HPP
#define TIGHTDB_COLUMN_LINK_HPP

#include <tightdb/column.hpp>
#include <tightdb/column_linkbase.hpp>
#include <tightdb/column_backlink.hpp>

namespace tightdb {

/// A link column is an extension of an integer column (Column) and maintains
/// its node structure.
///
/// The individual values in a link column are indexes of rows in the target
/// table (offset with one to allow zero to indicate null links.) The target
/// table is specified by the table descriptor.
class ColumnLink: public ColumnLinkBase {
public:
    ColumnLink(Allocator&, ref_type ref); // Throws
    ~ColumnLink() TIGHTDB_NOEXCEPT TIGHTDB_OVERRIDE;

    static ref_type create(Allocator&, std::size_t size = 0);

    //@{

    /// is_null_link() is shorthand for `get_link() == tightdb::npos`,
    /// nullify_link() is shorthand foe `set_link(tightdb::npos)`, and
    /// insert_null_link() is shorthand for
    /// `insert_link(tightdb::npos)`. set_link() returns the original link, with
    /// `tightdb::npos` indicating that it was null.

    std::size_t get_link(std::size_t row_ndx) const TIGHTDB_NOEXCEPT;
    bool is_null_link(std::size_t row_ndx) const TIGHTDB_NOEXCEPT;
    std::size_t set_link(std::size_t row_ndx, std::size_t target_row_ndx);
    void nullify_link(std::size_t row_ndx);
    void insert_link(std::size_t row_ndx, std::size_t target_row_ndx);
    void insert_null_link(std::size_t row_ndx);

    //@}

    void move_last_over(std::size_t, std::size_t, bool) TIGHTDB_OVERRIDE;
    void clear(std::size_t, bool) TIGHTDB_OVERRIDE;
    void cascade_break_backlinks_to(std::size_t, CascadeState&) TIGHTDB_OVERRIDE;
    void cascade_break_backlinks_to_all_rows(std::size_t, CascadeState&) TIGHTDB_OVERRIDE;

#ifdef TIGHTDB_DEBUG
    void Verify(const Table&, std::size_t) const TIGHTDB_OVERRIDE;
#endif

protected:
    friend class ColumnBackLink;
    void do_nullify_link(std::size_t row_ndx, std::size_t old_target_row_ndx) TIGHTDB_OVERRIDE;
    void do_update_link(std::size_t row_ndx, std::size_t old_target_row_ndx,
                        std::size_t new_target_row_ndx) TIGHTDB_OVERRIDE;

private:
    void remove_backlinks(std::size_t row_ndx);
};


// Implementation

inline ColumnLink::ColumnLink(Allocator& alloc, ref_type ref):
    ColumnLinkBase(alloc, ref) // Throws
{
}

inline ColumnLink::~ColumnLink() TIGHTDB_NOEXCEPT
{
}

inline ref_type ColumnLink::create(Allocator& alloc, std::size_t size)
{
    return Column::create(alloc, Array::type_Normal, size); // Throws
}

inline std::size_t ColumnLink::get_link(std::size_t row_ndx) const TIGHTDB_NOEXCEPT
{
    // Map zero to tightdb::npos, and `n+1` to `n`, where `n` is a target row index.
    return to_size_t(ColumnLinkBase::get(row_ndx)) - size_t(1);
}

inline bool ColumnLink::is_null_link(std::size_t row_ndx) const TIGHTDB_NOEXCEPT
{
    // Null is represented by zero
    return ColumnLinkBase::get(row_ndx) == 0;
}

inline std::size_t ColumnLink::set_link(std::size_t row_ndx, std::size_t target_row_ndx)
{
    int_fast64_t old_value = ColumnLinkBase::get(row_ndx);
    std::size_t old_target_row_ndx = to_size_t(old_value) - size_t(1);
    if (old_value != 0)
        m_backlink_column->remove_one_backlink(old_target_row_ndx, row_ndx); // Throws

    int_fast64_t new_value = int_fast64_t(size_t(1) + target_row_ndx);
    ColumnLinkBase::set(row_ndx, new_value); // Throws

    if (target_row_ndx != tightdb::npos)
        m_backlink_column->add_backlink(target_row_ndx, row_ndx); // Throws

    return old_target_row_ndx;
}

inline void ColumnLink::nullify_link(size_t row_ndx)
{
    set_link(row_ndx, tightdb::npos); // Throws
}

inline void ColumnLink::insert_link(std::size_t row_ndx, std::size_t target_row_ndx)
{
    int_fast64_t value = int_fast64_t(size_t(1) + target_row_ndx);
    ColumnLinkBase::insert(row_ndx, value); // Throws

    if (target_row_ndx != tightdb::npos)
        m_backlink_column->add_backlink(target_row_ndx, row_ndx); // Throws
}

inline void ColumnLink::insert_null_link(size_t row_ndx)
{
    insert_link(row_ndx, tightdb::npos); // Throws
}

inline void ColumnLink::do_nullify_link(std::size_t row_ndx, std::size_t)
{
    ColumnLinkBase::set(row_ndx, 0);
}

inline void ColumnLink::do_update_link(std::size_t row_ndx, std::size_t,
                                       std::size_t new_target_row_ndx)
{
    // Row pos is offset by one, to allow null refs
    ColumnLinkBase::set(row_ndx, new_target_row_ndx + 1);
}

} //namespace tightdb

#endif //TIGHTDB_COLUMN_LINK_HPP
